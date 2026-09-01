from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [('api', '0040_alter_healthrecord_created_at_alter_meal_created_at_and_more')]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='otp',
            field=models.CharField(blank=True, max_length=128, null=True),
        ),
        migrations.AddField(
            model_name='user',
            name='token_version',
            field=models.PositiveIntegerField(default=0),
        ),
    ]
