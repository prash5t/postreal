from rest_framework.pagination import PageNumberPagination


class UserListPagination(PageNumberPagination):
    """
    Custom PageNumberPagination for user account with page size 50. 
    """
    page_size = 50
    page_size_query_param = 'page_size'  
    max_page_size = 50