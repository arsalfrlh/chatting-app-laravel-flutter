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
                <h1>Register User</h1>
                @if ($errors->any())
                    <div class="pt-3 alert-danger">
                        <ul>
                            @foreach ($errors->all() as $item)
                                <li>{{$item}}</li>
                            @endforeach
                        </ul>
                    </div>
                @endif
                <form action="/register/proses" method="POST">
                    @csrf
                    <div class="form-group">
                      <label for="formGroupExampleInput">Name</label>
                      <input type="text" class="form-control" id="formGroupExampleInput" placeholder="Name" name="name">
                    </div>
                    <div class="form-group">
                      <label for="formGroupExampleInput">Email</label>
                      <input type="text" class="form-control" id="formGroupExampleInput" placeholder="Email" name="email">
                    </div>
                    <div class="form-group">
                      <label for="formGroupExampleInput2">Password</label>
                      <input type="password" class="form-control" id="formGroupExampleInput2" placeholder="Password" name="password">
                    </div>
                    <div class="form-group">
                      <input type="submit" value="Register" class="btn btn-success"> <a href="/login" class="btn btn-primary">Login</a>
                    </div>
                  </form>
            </div>
          </div>

          <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
          @if ($pesan = Session::get('gagal'))
              <script>Swal.fire('{{$pesan}}');</script>
          @endif

          @if ($pesan = Session::get('logout'))
              <script>Swal.fire('{{$pesan}}');</script>
          @endif
    </div>
</body>
</html>