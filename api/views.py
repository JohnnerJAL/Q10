from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from rest_framework.parsers import JSONParser
from django.http.response import JsonResponse

from api.models import User
from api.serializers import UserSerializer

# Create your views here.

@csrf_exempt
def userApi(request, id=0):
    if request.method=='GET':
        users = User.objects.all()
        users_serializer = UserSerializer(users, many=True)
        return JsonResponse(users_serializer.data, safe=False)
    elif request.method=='POST':
        user_data = JSONParser().parse(request)
        user_serializer = UserSerializer(data=user_data)
        if user_serializer.is_valid():
            user_serializer.save()
            return JsonResponse('Added successfully', safe=False)
        return JsonResponse('Failed to add', safe=False)
    elif request.method=='PUT':
        user_data = JSONParser().parse(request)
        user = User.objects.get(id=user_data['id'])
        user_serializer = UserSerializer(user, data=user_data)
        if user_serializer.is_valid():
            user_serializer.save()
            return JsonResponse('Update successfully', safe=False)
        return JsonResponse('Failed to update')
    elif request.method=='DELETE':
        user = User.objects.get(id=id)
        user.delete()
        return JsonResponse('Deleted successfully', safe=False)