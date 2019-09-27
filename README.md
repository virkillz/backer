# Backer

Backer is a subscribtion based donation platform. It geared toward community and social activity.

For more background information click [here](background.md)


## Feature

Backer relies on 3 primary feature. The full list of backlog can be seen [here](backlog.md). We occationally clean things up and move it to [backlog archieve](backlog_archieve.md)

Target milestone we docummented [here](milestone-plan.md)

### Donee cataloque

Public can browse a lot of donee grouped by its category. Each of them will have it's own profile page explaining their activity, list of their top backer, and list of post.

### Subscribtion mechanism

Backer can subscribe into Donee by paying monthly donation. Active backers status are tracked. Donee can give some benefit for backer according to it's level.

### Post timeline

Donee can create post for public or set to be visible only by minimum level of backer. 




## Installation

#### Requirement

  Make sure your machine have these installed:
  * Elixir ~1.7.4
  * Postgre ~9.0.0
  * Nodejs ~10.0.0

#### How to install
  * Fork this repo and clone to your local machine
  * Cd into the directory and install dependencies with `mix deps.get`
  * Edit database setting at `config/dev.exs` and match your postgresql username and password
  * if you are on freshly installed ubuntu run `sudo apt-get install build-essential`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Run seed to prepopulate data: `cd .. && mix run priv/repo/seeds.exs`
  * Start Phoenix endpoint with `mix phx.server`

### Credentials

#### As User
Visit [`localhost:4000`](http://localhost:4000)
List of dummy user:

```
username: 

donee1@tester.com
donee2@tester.com
donee3@tester.com
donee4@tester.com
donee5@tester.com
donee6@tester.com
backer1@tester.com
backer2@tester.com
backer3@tester.com
backer4@tester.com
backer5@tester.com
backer6@tester.com
backer7@tester.com
backer8@tester.com
backer9@tester.com
backer10@tester.com

password for all:
virus123

```

Or simply register your own, manually edit 'is_verified' from admin panel to true, and login.

### For Admin
Visit [`localhost:4000/admin`](http://localhost:4000/admin)

```
username: 'administrator' 
passsword 'administrator'

```

