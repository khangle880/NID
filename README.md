# NID - No Idea App

My Flutter project.
With member
- 18520888 - Lê Nhị Khang
- 18520757 - Võ Đoàn Minh Hiếu
- 18521051 - Phạm Thăng Long
- 18520864 - Hoàng Thế Kỷ

## Getting Started

You can find app apk in Release tag in this github

### Account for test:

- Account 1:
-- Email: daiacma880v1@gmail.com
-- Password: a123123123

- Account 1:
-- Email: abc@gmail.com
-- Password: a123123123

## Table of Contents

- [Requirements](#requirements)
- [Todo](#todo)
  - [Features](#features)
  - [Bugs](#bugs)
- [Things I created](#created)
  - [Firestore Schema](#schema)
  - [Firestore Rule](#rule)
- [Note](#note)

## Requirements for this project<a name = "requirements"></a>

- Android > 24
- Firebase Service
- Bloc Pattern
- Provider Pattern

## Things todo<a name = "todo"></a>

### Features<a name = "features"></a>

- [x] Try code demo
- [x] Create folder structure
- [x] Create auth ui
- [x] Create Forgot password custom function
- [x] Design database schema
- [x] Fake a few data
- [x] Create Reposity follow db firestore
- [x] Create Todo Home UI
- [x] View task by today, month
- [x] View list (projects, quick notes)
- [x] Add popup and page
- [x] Delete feature
- [ ] Delete quick note
- [ ] Edit feature
- [x] Profile page
- [x] View task detail
- [x] Share data task, project within (creator, member, assignee)
- [ ] Handle menu in task detail
- [x] Add Ads
- [x] Add Notification

### Bugs <a name = "bugs"></a>

<b>These are very big bug I found, some have proper solutions, some don't</b>

- [x] Firebase can't not custom feature forgot password
- Problem: Firebase lack of function
- Solution: Store auth data in firestore
- - Write rule for admin can edit, and owner only update
- - Idea quiet not security but temporarily sovle

- [x] Tab view quite lag
- - Problem: Tab alway rebuild
- - Solution: use "AutomaticKeepAliveClientMixin"

- [x] Popup not access bloc from previous context
- - Problem: Mostly popup use variable "useRootNavigator = true", becauce popup pushed in route
- - Problem: builder function (context) ..., this context is new not context previous
- - Solution: "useRootNavigator = false" and "(context)" -> "(_)"
- - Solution: I dont fully undertand becauce this solution temporary

- [ ] Mutil navigator can error duplication key
- - Problem: No idea!
- - Solution: No Idea!

## Some thing i had<a name = "created"></a>

### Firebase Schema<a name = "schema"></a>

----------

### These Rules for firestore i'm proud of<a name = "rule"></a>

- - Rule setting only user authenticated see private info
- - Only members in participants field can view data

[**Rules Link.**](https://firebasestorage.googleapis.com/v0/b/icon-af204.appspot.com/o/rule_aking.png?alt=media&token=62f5eeca-70ed-48a4-a860-0a9aff29febd)<br>


## Some Note<a name = "note"></a>

### Username only can email

Because lack of function for authentication and only email auth can custom otp

Firebase support phone, button login need otp, and UI need password, so i only use email auth

Use phone quite inconvenience, and UI for username password more beautiful

### Show Dialog

Show Dialog mostly navigator.push(context, useRootNavigator)

Because Provider and Bloc inheritance from context, and usually they dont placed at root navigator

So you should useRootNavigator = false, and (context) into (_) to use bloc from previous route

But it's not entirely correct, there are still exceptions
