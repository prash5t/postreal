from django import forms


class UserIdValidationForm(forms.Form):
    """
    Field validation for user UUID.
    """
    userId = forms.UUIDField(required=True)


class CommentValidationForm(forms.Form):
    """
    Field validation for comment.
    """
    postId = forms.IntegerField(required=True)
    comment = forms.CharField(max_length=150, required=True)


class OtpValidationForm(forms.Form):
    """
    Field validation for otp verification.
    """
    otp = forms.IntegerField(required=True)
    username = forms.CharField(max_length=50, required=True) 


class NotificationDeviceForm(forms.Form):
    """
    Field validation for notification token of device.
    """
    notification_token = forms.CharField(max_length=350, required=True) 