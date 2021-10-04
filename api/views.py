from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from rest_framework.parsers import JSONParser
from django.http.response import JsonResponse
from django.db import connection

from api.models import Game, User, Test
from api.serializers import UserSerializer, TestSerializer, GameSerializer

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

@csrf_exempt
def userLogin(request):
    if request.method=='POST':
        user_data = JSONParser().parse(request)
        user = User.objects.filter(alias=user_data['alias'], key=user_data['key'])
        users_serializer = UserSerializer(user, many=True)
        return JsonResponse(users_serializer.data, safe=False)

@csrf_exempt
def testApi(request, id=0):
    if (request.method=='GET' and id!=0):
        readTest = connection.cursor()
        readTest.execute("call readTest('"+id+"')")
        storedProcedure = readTest.fetchall()
        return JsonResponse(storedProcedure, safe=False)
    if request.method=='GET':
        tests = Test.objects.all()
        tests_serializer = TestSerializer(tests, many=True)
        return JsonResponse(tests_serializer.data, safe=False)

@csrf_exempt
def gameApi(request):
    if request.method=='POST':
        game_data = JSONParser().parse(request)
        createGame = connection.cursor()
        Test_id = str(game_data['Test_id'])
        User_id = str(game_data['User_id'])
        createGame.execute("call createGame('"+'1'+"', '"+User_id+"', '"+Test_id+"')")
        # game_serializer = UserSerializer(data=game_data)
        # if game_serializer.is_valid():
        #     createGame = connection.cursor()
        #     createGame.execute("call createGame('"+1+"', '"+game_data['User_id']+"', '"+game_data['Test_id']+"')")
        #     # game_serializer.save()
        #     return JsonResponse('Created successfully', safe=False)
        createGame.execute('''
        SELECT *
        FROM Q10.Games
        order by createdOn desc
        LIMIT 1;
        ''')

        game = createGame.fetchone()
        return JsonResponse({ 'Games_id': game[0] }, safe=False)
    elif request.method=='PUT':
        user_data = JSONParser().parse(request)
        user = Game.objects.get(id=user_data['id'])
        print(user)
        print(user_data)
        user_serializer = GameSerializer(user, data=user_data)
        if user_serializer.is_valid():
            user_serializer.save()
            return JsonResponse('Update successfully', safe=False)
        return JsonResponse('Failed to update', safe=False)
