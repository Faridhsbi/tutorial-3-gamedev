# Tutorial 3 - Introduction to Game Programming with GDScript for Implementing Basic 2D Game Mechanics
####  Nama: Muhammad Farid Hasabi
#### NPM : 2306152512
---

## 1. Latihan Mandiri: Eksplorasi Mekanika Karakter

Saya mengimplementasikan tiga mekanika pergerakan tambahan pada `Player`, antara lain:

### A. Double Jump
* Memungkinkan pemain untuk melompat sekali lagi saat sedang berada di udara.
* **Proses Pengerjaan:** 
	1. Saya menambahkan variabel *state* `jump_count` untuk melacak jumlah lompatan, dan konstanta `max_jumps = 2`.
	2. Di dalam `_physics_process()`, variabel `jump_count` direset menjadi 0 setiap kali karakter menyentuh lantai yang dicek menggunakan fungsi bawaan `is_on_floor()`.
	3. Ketika tombol lompat (`ui_up`) ditekan, sistem akan mengecek apakah `jump_count < max_jumps`. Jika ya, vektor kecepatan Y (`velocity.y`) akan di-override secara instan dengan nilai negatif (`jump_speed`), lalu `jump_count` ditambah 1.

### B. Dashing
* Memberikan dorongan kecepatan horizontal secara masif untuk waktu yang singkat ketika pemain menekan tombol arah dua kali secara beruntun (*double-tap*).
* **Proses Pengerjaan:**
	1. Untuk mendeteksi *double-tap*, saya merekam waktu dalam milidetik setiap kali tombol arah ditekan menggunakan fungsi `Time.get_ticks_msec()`.
	2. Jika selisih waktu antara tekanan tombol saat ini dan sebelumnya lebih kecil dari `double_tap_window`, *state* `is_dashing` diaktifkan menjadi `true`.
	3. Saat *state* `is_dashing` aktif, pergerakan dikontrol oleh sebuah *timer* (`dash_timer`). Kecepatan karakter (`velocity.x`) diatur ke `dash_speed` yang tinggi, dan efek gravitasi dihilangkan sementara (`velocity.y = 0`) agar karakter meluncur lurus. Setelah timer habis, status kembali normal.

### C. Crouching
* Mengubah postur karakter menjadi posisi jongkok menggunakan animasi khusus, memungkinkan karakter bergerak jongkok dengan kecepatan yang dikurangi.
* **Proses Pengerjaan:**
	1. Awalnya, saya sempat mencoba memodifikasi skala matriks sumbu Y (`scale.y = 0.5`) pada visual dan hitbox. Namun, pendekatan ini menimbulkan *physics bug* (karakter terangkat dari lantai dan memicu animasi jatuh berulang kali). Oleh karena itu, saya beralih menggunakan pendekatan *State Variable* murni.
	2. Saat tombol bawah (`ui_down`) ditahan dan karakter berada di lantai (`is_on_floor()`), *state* `is_crouching` diaktifkan menjadi `true`, dan batas kecepatan berjalan (`current_speed`) dibatasi menjadi `crouch_speed`.
	3. Pada blok evaluasi animasi, jika `is_crouching` bernilai `true`, engine akan memprioritaskan pemutaran animasi `"crouch"`. Saya juga menambahkan logika agar karakter tetap bisa berbalik arah (`flip_h`) apabila bergerak jongkok ke kiri atau kanan.
	4. Ketika tombol dilepas, `is_crouching` kembali di-reset menjadi `false`, dan karakter kembali ke kecepatan serta animasi pergerakan normalnya.
---

## 2. Fitur Tambahan

Selain mekanik diatas, saya juga menambahkan beberapa fitur berikut:

### Implementasi Animasi Sprite
* Node `Sprite2D` statis digantikan dengan `AnimatedSprite2D`. Saya mengimplementasikan sistem pergantian animasi sederhana berdasarkan status pergerakan vektor.
* Karakter memiliki animasi "Idle", "Walk", "Jump", dan "Dash". Saya juga memodifikasi properti `flip_h` untuk membalikkan wajah *sprite* secara otomatis agar sesuai dengan arah vektor kecepatan (`velocity.x`).

### Sistem Musuh (Zombie Patroling)
* Saya membuat *scene* terpisah untuk musuh bertipe `CharacterBody2D` (Zombie) lengkap dengan animasinya.
* Menggunakan batas spasial. Posisi awal zombie (`start_x`) dicatat pada fungsi `_ready()`. Jika jarak saat ini melewati batas `patrol_distance` ke kanan atau ke kiri, variabel arah (`direction`) akan dikalikan dengan `-1` sehingga zombie berbalik arah secara otomatis tanpa harus menabrak tembok.

### Respawn
* Zombie memiliki node pendeteksi `Area2D` untuk Sensor Hitbox yang ukurannya sedikit lebih besar dari `CollisionShape2D` fisiknya.
* Jika objek dengan nama "Player" bersinggungan (*overlap*) dengan Area2D tersebut, sebuah *Signal* (`body_entered`) akan terpicu. Sinyal ini memanggil fungsi `respawn()` pada skrip Player, yang secara instan mereset koordinat `global_position` pemain kembali ke posisi saat pertama kali level dimuat (`spawn_point`).

### Camera Smoothing & Limits
* `Camera2D` ditambahkan sebagai *child* dari Player agar kamera terus mengikuti karakter.
* Fitur `Position Smoothing` diaktifkan untuk memberikan efek sinematik dan mengurangi efek kaku pada kamera. Saya juga mengatur properti `Limit` agar kamera tidak menyorot ruang kosong saat pemain bergerak ke ujung area. 

### Win State UI & Scene Pausing
* Saya menambahkan sebuah area garis akhir (`ObjectiveArea`) menggunakan `Area2D`. 
* UI ending dirakit menggunakan `CanvasLayer` (berisi tulisan *You Win*, tombol *Try Again*, dan *Exit*). UI ini disembunyikan secara bawaan.
* Saat pemain menyentuh objectiveArea, UI akan muncul dan fungsi `get_tree().paused = true` dipanggil untuk membekukan seluruh pergerakan fisika permainan, kemudian menunggu input pemain melalui tombol UI.

---

## Referensi
1. **Godot Docs - CharacterBody2D:** [https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html)
2. **Godot Docs - Using Area2D:** [https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html](https://docs.godotengine.org/en/stable/tutorials/physics/using_area_2d.html)
3. **Godot Docs - Signals:** [https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html)
4. **Godot Docs - Viewport and Canvas Transforms (UI):** [https://docs.godotengine.org/en/stable/tutorials/2d/2d_transforms.html](https://docs.godotengine.org/en/stable/tutorials/2d/2d_transforms.html)
5. **Youtube - Godot 4 2D Sprite Animation Tutorial For Beginners** [https://youtu.be/gOSEdi6oBjQ?si=YK1YMIh_gpq5RBFI](https://youtu.be/gOSEdi6oBjQ?si=YK1YMIh_gpq5RBFI)
