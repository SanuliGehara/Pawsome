from django.db import models

class Cat_Food(models.Model):
    name = models.CharField(max_length=255)
    brand = models.CharField(max_length=255, blank=True, null=True)
    type = models.CharField(max_length=50, choices=[('dry', 'Dry'), ('wet', 'Wet')])
    ingredients = models.TextField()
    age_group = models.CharField(max_length=50, choices=[('kitten', 'Kitten'), ('adult', 'Adult'), ('senior', 'Senior')])
    price = models.DecimalField(max_digits=10, decimal_places=2)
    availability = models.BooleanField(default=True)
    image_url = models.URLField(blank=True, null=True)

    def __str__(self):
        return f"{self.name} ({self.brand})"
