from django.conf.urls import url
from api import views

urlpatterns = [
    url(r'^user$', views.userApi),
    url(r'^user/([0-9]+)$', views.userApi),
    url(r'^users/register$', views.userApi),
    #
    url(r'^users/login$', views.userLogin),
    # Test
    url(r'^tests$', views.testApi),
    url(r'^tests/([0-9]+)$', views.testApi),
    # Game
    url(r'^games$', views.gameApi)
]