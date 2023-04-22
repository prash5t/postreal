from django import forms


class UserIdValidationForm(forms.Form):
    """
    Field validation of user UUID.
    """
    userId = forms.UUIDField(required=True)


class CommentValidationForm(forms.Form):
    """
    Field validation of comment.
    """
    postId = forms.IntegerField(required=True)
    comment = forms.CharField(max_length=150, required=True)