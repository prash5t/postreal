from django import forms


class UserIdValidationForm(forms.Form):
    userId = forms.UUIDField(required=True)


class CommentValidationForm(forms.Form):
    postId = forms.IntegerField(required=True)
    comment = forms.CharField(max_length=150, required=True)