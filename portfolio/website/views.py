from django.shortcuts import render, HttpResponse

# Create your views here.
def home(request):
    return render(request, "index.html")   # sends this back to the client
                                           # on their browser