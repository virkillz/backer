# Backer

## EPIC

### Make Doneezone placeholder works
- [ ] Create placeholder for about
- [ ] Create placeholder for post
- [ ] Create placeholder for backers
- [ ] Create placeholder for finance
- [ ] Create placeholder for statistic
- [ ] Create placeholder for settings

### Make backing flow works
- [ ] Simplify payment form
- [X] Make the form works
- [ ] Create Invoice detail page
- [ ] Make the Invoice detail page works
- [ ] Make invoice list works
- [x] Redirect if not logged in
- [x] Capture intention to redirect to previous page after login
- [x] Make create invoice works
- [x] Ensure changing status from backend reflected on front end.


### Make My Donee list and donee counter works

Note: Depends on previous epic
- [ ] Test end to end donate cycle.
- [ ] Ensure backing month update backer count.
- [ ] Update my donee list to make it dynamic

### Make backer profile page
- [ ] Create endpoint
- [ ] Hook to dynamic data


### Make top backer below donee profile works
- [ ] Make donee profie dynamic


## SMALL TODO
- [ ] Default donee/username must be dynamic. by default goes to post if post is not empty. 
- [ ] Change favicon backer admin
- [x] Remove category from private donee sidebar
- [ ] Display backer page
- [x] Make login working
- [x] Make register working
- [ ] Display dynamic donee at "/"
- [ ] Register backer better have automatic username such as backer1
- [ ] user cannot create backer[number] below his user id
- [ ] Fix 'please verify page'
- [ ] Register email which already registered but not yet verified must be valid.


## PHASE 1 Feature
- [ ] Backer can register
- [ ] Donee can register separately
- [ ] Donee can post
- [ ] Backer can donate
- [ ] Admin can change donation status
- [ ] Backer can see the donation status
- [ ] Backer can browse the post and comment
- [ ] Visisting nonexistent "/donee/nonexistuser" shows error, need to check other variant as well.



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

