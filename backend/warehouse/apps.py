from django.apps import AppConfig


class WarehouseConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'warehouse'

    def ready(self):
        # Import signal handlers to ensure pallet consistency
        from . import signals  # noqa: F401
