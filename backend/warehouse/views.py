from rest_framework import viewsets

from .models import Product, Supplier, Pallet, Warehouse, WarehouseObject
from .serializers import (
    ProductSerializer,
    SupplierSerializer,
    PalletSerializer,
    WarehouseSerializer,
    WarehouseObjectSerializer,
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


class WarehouseViewSet(viewsets.ModelViewSet):
    queryset = Warehouse.objects.all()
    serializer_class = WarehouseSerializer
    permission_classes = [Everyone]


class WarehouseObjectViewSet(viewsets.ModelViewSet):
    queryset = WarehouseObject.objects.all()
    serializer_class = WarehouseObjectSerializer
    permission_classes = [Everyone]
