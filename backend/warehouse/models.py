import uuid

from django.db import models

class Product(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    sku = models.CharField(max_length=20, unique=True, editable=False)
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    max_boxes_per_pallet = models.IntegerField()
    expiry_date = models.DateField()

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

class Supplier(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255)

class Pallet(models.Model):
    STATUS_CHOICES = [
        ('full', 'Full'),
        ('empty', 'Empty'),
        ('partial', 'Partial'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    status = models.CharField(max_length=7, choices=STATUS_CHOICES)
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
