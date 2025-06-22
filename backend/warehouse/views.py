from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Product, Supplier, Pallet, Warehouse, WarehouseObject, ProductInstance
from .serializers import (
    ProductSerializer,
    SupplierSerializer,
    PalletSerializer,
    WarehouseSerializer,
    WarehouseObjectSerializer,
    ProductInstanceSerializer,
)
from .permissions import Everyone


class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [Everyone]


class SupplierViewSet(viewsets.ModelViewSet):
    queryset = Supplier.objects.all()
    serializer_class = SupplierSerializer
    permission_classes = [Everyone]


class PalletViewSet(viewsets.ModelViewSet):
    queryset = Pallet.objects.all()
    serializer_class = PalletSerializer
    permission_classes = [Everyone]

    @action(detail=False, methods=['get'])
    def by_sku(self, request):
        sku = request.query_params.get('sku')
        if not sku:
            return Response({'error': 'SKU is required.'}, status=400)
        pallets = Pallet.objects.filter(product_instance__product__sku=sku)
        return Response(PalletSerializer(pallets, many=True).data)

    @action(detail=True, methods=['post'])
    def dispatch_pallet(self, request, pk=None):
        pallet = self.get_object()
        pallet.product_instance = None
        pallet.reserved = False
        pallet.reserved_customer = None
        pallet.save()
        return Response({'message': 'Pallet dispatched'}, status=200)


class WarehouseViewSet(viewsets.ModelViewSet):
    queryset = Warehouse.objects.all()
    serializer_class = WarehouseSerializer
    permission_classes = [Everyone]


class WarehouseObjectViewSet(viewsets.ModelViewSet):
    queryset = WarehouseObject.objects.all()
    serializer_class = WarehouseObjectSerializer
    permission_classes = [Everyone]

    @action(detail=True, methods=['post'])
    def validateSpace(self, request, pk=None):
        sku = request.data.get('sku')
        number_of_boxes = request.data.get('number_of_boxes')
        warehouse_object = self.get_object()
        empty_pallets = Pallet.objects.filter(
            product_instance__isnull=True,
            warehouse_object__warehouse=warehouse_object.warehouse
        )
        if not sku or not number_of_boxes:
            return Response({'error': 'SKU and number of boxes are required.'}, status=400)
        product = Product.objects.filter(sku=sku).first()
        if not product:
            return Response({'error': 'Product not found.'}, status=404)
        empty_pallet_ids = empty_pallets.values_list('id', flat=True)
        number_of_needed_pallets = (number_of_boxes + product.max_boxes_per_pallet - 1) // product.max_boxes_per_pallet
        if len(empty_pallet_ids) < number_of_needed_pallets:
            return Response({'error': 'Not enough empty pallets available.'}, status=400)
        return Response({'empty_pallets': list(empty_pallet_ids), 'pallets_needed': number_of_needed_pallets}, status=200)
    
    @action(detail=True, methods=['post'])
    def reservePallets(self, request, pk=None):
        sku = request.data.get('sku')
        number_of_boxes = request.data.get('number_of_boxes')
        list_of_pallets = request.data.get('list_of_pallets', [])

        warehouse_object = self.get_object()
        with Pallet.objects.select_for_update().using('default').defer('reserved_customer').filter(
            id__in=list_of_pallets,
            warehouse_object__warehouse=warehouse_object.warehouse,
        ) as pallets:
            product = Product.objects.filter(sku=sku).first()
            if not product:
                return Response({'error': 'Product not found.'}, status=404)
            empty_pallets = pallets.filter(product_instance__isnull=True)
            number_of_needed_pallets = (number_of_boxes + product.max_boxes_per_pallet - 1) // product.max_boxes_per_pallet
            if len(empty_pallets) < number_of_needed_pallets:
                return Response({'error': 'Not enough empty pallets available.'}, status=400)
            for pallet in empty_pallets[:number_of_needed_pallets]:
                pallet.reserved = True
                pallet.reserved_customer = request.user.id
                pallet.save()
            return Response({'message': 'Pallets reserved successfully.'}, status=200)
        
    @action(detail=True, methods=['post'])
    def releasePallets(self, request, pk=None):
        list_of_pallets = request.data.get('list_of_pallets', [])
        warehouse_object = self.get_object()
        with Pallet.objects.select_for_update().using('default').filter(
            id__in=list_of_pallets,
            warehouse_object__warehouse=warehouse_object.warehouse,
        ) as pallets:
            for pallet in pallets:
                if pallet.reserved and pallet.reserved_customer == request.user.id:
                    pallet.reserved = False
                    pallet.reserved_customer = None
                    pallet.save()
            return Response({'message': 'Pallets released successfully.'}, status=200)
        
    @action(detail=True, methods=['get'])
    def getReservedPallets(self, request, pk=None):
        warehouse_object = self.get_object()
        sku = request.query_params.get('sku')
        if not sku:
            return Response({'error': 'SKU is required.'}, status=400)
        product = Product.objects.filter(sku=sku).first()
        if not product:
            return Response({'error': 'Product not found.'}, status=404)
        reserved_pallets = Pallet.objects.filter(
            product_instance__isnull=False,
            product_instance__product=product,
            reserved=True,
            reserved_customer=request.user.id,
            warehouse_object__warehouse=warehouse_object.warehouse
        )
        reserved_pallet_ids = reserved_pallets.values_list('id', flat=True)
        return Response({'reserved_pallets': list(reserved_pallet_ids)}, status=200)
    

class ProductInstanceViewSet(viewsets.ModelViewSet):
    queryset = ProductInstance.objects.all()
    serializer_class = ProductInstanceSerializer
    permission_classes = [Everyone]