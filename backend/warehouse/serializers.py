from rest_framework import serializers

from .models import Product, Supplier, Pallet, Warehouse, WarehouseObject, ProductInstance
class ProductInstanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductInstance
        fields = '__all__'



class ProductSerializer(serializers.ModelSerializer):
    instances = ProductInstanceSerializer(many=True, read_only=True)

    class Meta:
        model = Product
        fields = '__all__'
        read_only_fields = ('sku',)


class SupplierSerializer(serializers.ModelSerializer):
    pallets = serializers.PrimaryKeyRelatedField(
        many=True, read_only=True
    )

    class Meta:
        model = Supplier
        fields = '__all__'


class PalletSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pallet
        fields = '__all__'


class WarehouseObjectSerializer(serializers.ModelSerializer):
    pallet = PalletSerializer(read_only=True)
    product_instance = serializers.SerializerMethodField(read_only=True)
    class Meta:
        model = WarehouseObject
        fields = '__all__'

    def get_product_instance(self, obj):
        if obj.object_type == 'pallet' and hasattr(obj, 'pallet') and obj.pallet.product_instance:
            return ProductInstanceSerializer(obj.pallet.product_instance).data
        return None

    def validate(self, data):
        warehouse = data.get('warehouse')
        x = data.get('x')
        y = data.get('y')
        width = data.get('width')
        length = data.get('length')
        if x < 0 or y < 0 or x + width > warehouse.width or y + length > warehouse.length:
            raise serializers.ValidationError(
                "Object must be within warehouse bounds."
            )
        existing = WarehouseObject.objects.filter(warehouse=warehouse)
        if self.instance:
            existing = existing.exclude(pk=self.instance.pk)
        for obj in existing:
            if (
                x < obj.x + obj.width
                and x + width > obj.x
                and y < obj.y + obj.length
                and y + length > obj.y
            ):
                raise serializers.ValidationError(
                    "Object cannot overlap with existing objects."
                )
        return data


class WarehouseSerializer(serializers.ModelSerializer):
    warehouse_objects = WarehouseObjectSerializer(many=True, read_only=True)

    class Meta:
        model = Warehouse
        fields = '__all__'