# Manual Setup Notes

Some apps can't be managed declaratively, so additional setup needed for them is described here.

## Apps

### Linkding

- Password setup

```
sudo podman exec -it linkding python manage.py createsuperuser --username=raab --email=raab@example.com
```

- Add API Key
- Settings -> Show bookmark url

### Gotify

- Change default user/password
- Setup applications
- Change app keys

### File Browser

- Change default user/password
