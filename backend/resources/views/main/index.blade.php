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
    <div class="container">
        <div class="card" style="width: 40rem;">
            <div class="card-body btn-dark">
                <h1 class="d-inline">Hello {{ Auth::user()->name }}</h1> <a href="/logout" class="btn btn-danger mb-3">Logout</a>
                @foreach ($tampil as $user)
                <form action="/chat" method="POST">
                    @csrf
                    <div class="list-group">
                        <input type="hidden" value="{{ $user->id }}" name="receiver_id">
                        <input type="hidden" value="{{ $user->name }}" name="chat_with">
                        <input type="submit" value="{{ $user->name }}" class="list-group-item list-group-item-action btn-primary mt-2">
                    </div>
                </form>
                @endforeach
            </div>
          </div>

        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        @if ($pesan = Session::get('login'))
            <script>
                Swal.fire({
                position: "center",
                icon: "success",
                title: '{{ $pesan }}',
                showConfirmButton: false,
                timer: 1500
                });
            </script>
        @endif

        @if ($pesan = Session::get('register'))
            <script>
                Swal.fire({
                position: "center",
                icon: "success",
                title: '{{ $pesan }}',
                showConfirmButton: false,
                timer: 1500
                });
            </script>
        @endif
    </div>
</body>
</html>