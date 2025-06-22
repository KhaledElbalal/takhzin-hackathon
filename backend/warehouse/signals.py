from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.db.models import Max
from .models import WarehouseObject, Pallet

@receiver(post_save, sender=WarehouseObject)
def ensure_pallet_consistency(sender, instance, created, **kwargs):
    """Create or remove pallets when warehouse objects change."""
    if instance.object_type == 'pallet':
        if not hasattr(instance, 'pallet'):
            max_id = Pallet.objects.aggregate(Max('id')).get('id__max') or 0
            Pallet.objects.create(id=max_id + 1, warehouse_object=instance)
    else:
        # If object type is no longer pallet, remove associated pallet if exists
        if hasattr(instance, 'pallet'):
            instance.pallet.delete()

# on_delete=CASCADE on Pallet.warehouse_object already handles deletion when
# a WarehouseObject is removed, but we keep this receiver for clarity.
@receiver(post_delete, sender=WarehouseObject)
def delete_pallet_on_object_delete(sender, instance, **kwargs):
    if hasattr(instance, 'pallet'):
        instance.pallet.delete()
