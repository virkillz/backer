# Milestone Target

## Milestone 0: Release MVP
Duration: 3 month
- [] Target finished: 1 January 2020

Target: Have a production ready version deployed. Everything visible is working. 
Create own legal entity. Have a pitchdeck. Start documenting expenses. Start distributing actual backing donation from own money to real donee.

user_setting

backer_id
group
key
value_string
value_integer


Breakdown
### September 2019

Target:
- [x] All front end screen is finished.
- [x] Basic backing payment flow is finished.
- [x] Create invoice detail page
- [x] Make invoice detail dynamic
- [x] Format all thousand separator and delimiter
- [x] All the text for about us, basic FAQ, landing page is finished.
- [x] Deploy alpha.backer.id 
- [x] Fix template generator
- [x] Donee can create submission to be considered.
- [x] Admin can edit donee's tagline
- [x] Create general config
- [x] Make the landing page featured donee dynamic
- [x] Fix about us header link
- [x] Fix link CTA landing page above footer 
- [x] Make contact us 
- [x] Hide post public donee profile
- [x] Hide post doneezone
- [x] Hide post backerzone
- [x] Add simple WoW animation

### October 2019

Target:
- [x] Fix logo color in header
- [x] Fix issue some donee doesn't have tier
- [x] Fix recommended donee in doneezone cannot be clicked
- [x] Make Backer public page backer list represent active backer.
- [x] Make all number in public backer profile real from data
- [x] If no backing yet, show somehting in doneezone
- [x] Make backer in doneezone and public donee works
- [x] Invoice must record donee_id and month directly. Not only through detail 
- [x] Make top backer in public donee profile works
- [x] Invoice should capture 'nominal'
- [x] Make backerzone 'keuangan' works 
- [x] Donee can edit their own profile
- [x] Backer can edit their own profile
- [x] Connect to cloud image storage
- [x] All avatar display must show object fit cover and center
- [x] Validate image type
- [x] Make the upload button better
- [x] Logout menu when mobile view didn't worked
- [x] Background upload can connct to S3 bucket.
- [x] Make public donee profile dynamic from DB
- [x] Change title into tagline
- [x] Add tag meta SEO dynamic into the front page
- [x] Remove Manual amount input in donate page
- [x] Change default tier
- [x] Fix footer simple version and make it component.
- [x] Make the link footer works.
- [x] Create meta tag placeholder
- [x] Connect to image processing service.
- [x] fix footer looks really ugly in mobile
- [x] explore looks bad in mobile
- [x] Backer can edit social media link
- [x] Fix Backerzone/my-donee-list avatar size not square
- [x] Fix Backerzone/my-donee-list riwayat donasi unclickable
- [x] Fix Backerzone/my-donee-list inactive color supposed to be gray
- [x] Side searchbar is redundant
- [x] Remove text go to donee mode if not donee!
- [x] Riwayat donasi when black must show soamething.
- [x] Explore list must contain tagline instead of title
- [x] Result page in search must contain tagile as well. Make it similar with explore

### Notification Feature
- [x] Make notification schema and function works.
- [x] Make notification functioning for backer waiting for payment.
- [ ] Make admin tidier.
- [ ] Broadcast notification.
- [ ] Make notification functioning for donee got new backer.
- [ ] Make notification functioning for backer payment approved.
- [x] Error after edit tagline.

### Search Feature
- [x] Dedicated search page
- [x] Make search functioning
- [x] Make search filter functioning


- [x] If backer already backing a donee. they cannot backing. they can only upgrade or extend.

### Backing Aggregate
- [x] Create backing aggregate schema. [backer_id, donee_id, last_amount, last_tier, status, score, backer_start]
- [x] continue Backer.Aggregate.build_aggregate

This is the first function called when somebody donate to a donee.

- [x] update_aggregate
- [x] Create script to update backing aggregate score.
- [ ] Create schema for scoring history. score come from contribution point accumulation.
- [ ] Create function to update backing status single.
- [ ] Create function to update backing status batch.

### Contribution_point

- [ ] schema contribution poin

### Reccomendation 

- [ ] figure it out how it worked.


### Connect to email service.
- [x] what is the best email service?

### Create landing page for backer.
- [x] Design landing page
- [ ] Create email form to inform when it launched.

### Optimize web performance
- [ ] resize logo


### Small changes
- [ ] Update the seed containing better tagline, profile overview and youtube video
- [ ] Create migration for backing_pitch
- [ ] Update seed for backing pitch
- [ ] Custom style oerview with UL/LI/ title, etc

### Preview mode
- [x] Preview mode: /preview
- [x] Publish on and off
- [x] If publish is off will show special page.


### November target

Target:
- [ ] Donee can create post.
- [ ] Backer can see correct post in timeline.
- [ ] Like and comment works
- [x] Connect to email service
- [ ] Connect to Facebook login and google.
- [ ] all multilang translation are finished

### Admin Portal
- [ ] Change to tailwind Proof of Concept
- [ ] Dashboard must works
- [ ] Admin portal must be able to find backer instead of drop down select



### December

Target:
- [ ] Notification works
- [ ] Suggestion box works
- [ ] Go live
- [x] Go crazy with front end transition and animation


Milestone 1: finding stable feature
Duration: 6 month
Target finished: 1  July 2020
Target: 100 Donee, 1000 Backer
2 fullstack engineer
Punya office /coworking space
2 fullstack engineer
Flutter developer
BD with marketing and community manager


Milestone 2: Build mobile and API.
Duration : 6 Month
Target: 1000 Donee, 10,000 Backer
Own office.
