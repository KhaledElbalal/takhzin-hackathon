from rest_framework.permissions import BasePermission

class Everyone(BasePermission):
    def has_permission(self, request, view):
        return True