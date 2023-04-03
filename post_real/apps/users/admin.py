from django.contrib import admin
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth.admin import UserAdmin
from .models import User
from django.contrib.auth.forms import UserChangeForm


class UserAdmin(BaseUserAdmin):
    form = UserChangeForm
    fieldsets = (
      (None, {'fields': ('username', 'email', 'password')}),
      (_('Personal info'), {'fields': ('first_name', 'last_name', 'phone_no')}),
      (_('Permissions'), {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
      (_('Important dates'), {'fields': ('last_login', 'date_joined')}),
      (_('user_info'), {'fields': ('bio', 'profilePicUrl')}),  
  )
    add_fieldsets = (
        (None, {
            'classes': ('wide', ),
            'fields': ('username', 'email', 'password1', 'password2'),
        }),
    )

    list_display = ['username', 'email', 'bio', 'is_staff']
    search_fields = ('username', 'email')
    ordering = ['username', 'email']

admin.site.register(User, UserAdmin)