<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
</head>
<body>
    <center>
    <div class="card mt-4" style="width: 50rem;">
        <div class="card-body btn-dark">
            <h4>Chat with {{ $chatWith }}</h4>
                <div style="height: 300px; overflow-y: scroll; border: 1px solid #ccc; padding: 10px;">
                    @foreach ($tampil as $chat)
                        @if ($chat->user->id == Auth::user()->id)
                            <div class="text-right"><h5>{{ $chat->user->name }}: {{ $chat->message }}</h5></div>
                            @if ($chat->gambar)
                                <div class="text-right"><img src="{{ asset('images/'.$chat->gambar) }}" width="150"></div>
                            @endif
                        @else 
                            <div class="text-left"><h5>{{ $chat->user->name }}: {{ $chat->message }}</h5></div>
                            @if ($chat->gambar)
                                <div class="text-left"><img src="{{ asset('images/'.$chat->gambar) }}" width="150"></div>
                            @endif
                        @endif
                    @endforeach
                </div>
                <form action="/message" method="POST" enctype="multipart/form-data" class="mt-2">
                    @csrf
                    <input type="hidden" name="chat_with" value="{{ $chatWith }}">
                    <input type="hidden" name="chat_id" value="{{ $chat_id }}">
                    <div class="input-group">
                        <div class="custom-file col-sm-2 mr-2">
                            <input type="file" class="custom-file-input" id="customFile" name="gambar">
                            <label class="custom-file-label" for="customFile">File</label>
                        </div>
                          <input type="text" name="message" class="form-control mr-2" required>
                        <div class="input-group-append">
                            <button class="btn btn-primary mr-2" type="submit">Kirim</button> <a href="/index" class="btn btn-warning">Kembali</a>
                        </div>
                    </div>
                </form>
        </div>
    </div>
    </center>
</body>
</html>