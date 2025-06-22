import uuid

from django.db import models

class Product(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    sku = models.CharField(max_length=20, unique=True, editable=False)
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    max_boxes_per_pallet = models.IntegerField()

    def save(self, *args, **kwargs):
        if not self.sku:
            last = Product.objects.order_by('-sku').first()
            if last and last.sku.startswith('SKU-'):
                try:
                    num = int(last.sku.replace('SKU-', ''))
                except ValueError:
                    num = 0
            else:
                num = 0
            self.sku = f"SKU-{num + 1:09d}"
        super().save(*args, **kwargs)


class ProductInstance(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name="instances")
    production_date = models.DateField(null=True, blank=True)
    batch_number = models.CharField(max_length=50, null=True, blank=True)
    expiry_date = models.DateField(null=True, blank=True)


class Supplier(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)

class Pallet(models.Model):
    id = models.IntegerField(primary_key=True)
    product_instance = models.ForeignKey(
        ProductInstance,
        related_name='pallets',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )
    warehouse_object = models.OneToOneField(
        'WarehouseObject',
        related_name='pallet',
        on_delete=models.CASCADE,
        null=True,
        blank=True,
    )
    reserved = models.BooleanField(default=False)
    reserved_customer = models.UUIDField(null=True, blank=True)
    supplier = models.ForeignKey(
        Supplier, related_name='pallets', on_delete=models.SET_NULL, null=True, blank=True
    )

class Warehouse(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)
    width = models.IntegerField()
    length = models.IntegerField()

class WarehouseObject(models.Model):
    OBJECT_TYPE_CHOICES = [
        ('obstacle', 'Obstacle'),
        ('pallet', 'Pallet'),
        ('road', 'Road'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    warehouse = models.ForeignKey(
        Warehouse, related_name='warehouse_objects', on_delete=models.CASCADE
    )
    object_type = models.CharField(max_length=8, choices=OBJECT_TYPE_CHOICES)
    width = models.IntegerField()
    length = models.IntegerField()
    x = models.IntegerField()
    y = models.IntegerField()
