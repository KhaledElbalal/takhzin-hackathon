from rest_framework import serializers

from .models import Product, Supplier, Pallet, Warehouse, WarehouseObject


class ProductSerializer(serializers.ModelSerializer):
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
    class Meta:
        model = WarehouseObject
        fields = '__all__'

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
    objects = WarehouseObjectSerializer(many=True, read_only=True)

    class Meta:
        model = Warehouse
        fields = '__all__'