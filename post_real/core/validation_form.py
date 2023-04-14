from django import forms


class FollowUnfollowForm(forms.Form):
    userId = forms.UUIDField(required=True)


class CommentForm(forms.Form):
    postId = forms.IntegerField(required=True)
    comment = forms.CharField(max_length=150, required=True)