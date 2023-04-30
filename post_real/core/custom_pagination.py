from rest_framework.pagination import PageNumberPagination


class UserListPagination(PageNumberPagination):
    """
    Custom PageNumberPagination for listing user account with page size 50. 
    """
    page_size = 30
    page_size_query_param = 'page_size'  
    max_page_size = 30


class PostListPagination(PageNumberPagination):
    """
    Custom PageNumberPagination for listing posts with page size 20. 
    """
    page_size = 20
    page_size_query_param = 'page_size'  
    max_page_size = 20


class CommentListPagination(PageNumberPagination):
    """
    Custom PageNumberPagination for listing comments with page size 20. 
    """
    page_size = 2
    page_size_query_param = 'page_size'  
    max_page_size = 15