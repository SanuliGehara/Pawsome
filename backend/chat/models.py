from django.db import models

class Message(models.Model):
    #sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name="sent_messages")
    #receiver = models.ForeignKey(User, on_delete=models.CASCADE, related_name="received_messages")
    sender = models.CharField(max_length=100)
    receiver = models.CharField(max_length=100)
    text = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.sender} -> {self.receiver}: {self.text[30]}"
