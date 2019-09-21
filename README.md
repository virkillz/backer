# Backer

# Todo

- [ ] Edit profile pledger cause error
- [ ] Make login working
- [ ] Make register working
- [ ] Display dynamic donee at "/explore"
- [ ] Display dynamic donee at "/"
- [ ] Register backer better have automatic username such as backer1
- [ ] user cannot create backer[number] below his user id
- [ ] Fix please verify page
- [ ] Register email which already registered but not yet verified must be valid.

## PHASE 1 Feature

- [ ] Backer can register
- [ ] Donee can register separately
- [ ] Donee can post
- [ ] Backer can donate
- [ ] Admin can change donation status
- [ ] Backer can see the donation status
- [ ] Backer can browse the post and comment

## To start:
  * Install dependencies with `mix deps.get`
  * Check your database setting at `config/dev.exs` and match your postgresql credential
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Run seed `mix run priv/repo/seeds.exs` (if you are from asset folder, dont forget to back to root project folder `cd ..`)
  * Start Phoenix endpoint with `mix phx.server`

### For User
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
You can register as a regular user.

### For Admin
You can visit [`localhost:4000/admin`](http://localhost:4000/admin) and login using username 'administrator' and passsword 'administrator'


## Use Backer Generator instead of phoenix!
You probably familiar using `phx.gen.html` like this:

`mix phx.gen.html Content Post post title:string content:string is_published:boolean`

Instead, you better use:

`mix backer.gen.html Content Post post title:string content:string is_published:boolean`

The later one will give nicer html output.

Put `resources "/post", PostController` in the router `/lib/Yourapp_web/router.ex`

Run migration `mix ecto.migrate`

Add link to your menu at '/lib/Yourapp_web/templates/layout/app.html.eex'

Bam it's done!

