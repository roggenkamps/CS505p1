# CS505p1

CS505 - project 1

This repository contains the code used for CS505, project 1, creating
a hybrid DAC/MAC authorization system for a database.  It implements a
Ruby-on-Rails web interface to the authorization system and implements
the following requirements taken from the assignment below.  It can be
accessed within the University of Kentucky's network at
[https://skro232.netlab.uky.edu](https://skro232.netlab.uky.edu).

All users have a password and must use their email address to log in,
which is just `<user>@example.com` replacing `<user>` with the user
identifier.  All users, except the `so` have a password consisting of
their identifier with 'pw' appended, so the password for `barb` is
`barbpw`.  The password for the Security Officer is `password`.

>  As mentioned above, he granularity of the privileges will be on the
>  level of tables (i.e. we control the access to the entire
>  table). Moreover, to simplify things a bit, instead of usual
>  privileges (read, write, update, etc) we will have just one. Think
>  about it as we give all of these privileges, or none at all. A user U
>  may grant further privileges on a table T to user U' (i.e. the table
>  assigned is inserted the record (U',T, B)) where B is a Boolean, if: 
> 
>     The table assigned contains the record (U,T,1)  
>     The table forbidden does not contain the record (U',T) 
> 
> The Security Officer (SO) may edit both tables (i.e. assigned and
> forbidden. If the SO attempts to modify the table forbidden by
> inserting the record (U,T), then if there is record (U,T,B) in the
> table permitted then this action (on the table assigned) is not at
> first allowed, and the SO must execute the overwrite action on the
> table assigned. Thus, after such action, the SO is warned that
> inserting (U,T) into forbidden may result in disruption of operations
> (because U' will no longer be able to access table T). Repeated action
> of inserting (U',T) into forbidden will succeed, and moreover,
> (U',T,G) will be removed from assigned, as well as all the subsequent
> grants from U'. The forbidding action must be logged. 
> 
> When a user U issues a command `grant A to U' when the record (U',T)
> is in forbidden then U will receive an error message `grant of access
> to T by U' unacceptable' and SO receives a message that U attempted to
> provide an access to U' to a restricted table. The lists must be
> mutually consistent, that is, one can not have a permission for the
> user (say) marek to access the table employees in the list assigned
> and at the same time a record forbidding such access on the table
> forbidden. The table forbidden can be modified only by SO.

We implement this with five tables: `assigneds`, `forbiddens`, `logs`,
`relations`, and `users`.

The `users` contains the user's `name`, their user identifier (`user`),
their `role` and `email`, as well as other information required and
maintained by the Devise authentication framework.

The `assigneds` table contains who granted access to whom to a table
and whether the grantee can also grant access.

The `forbiddens` table contains a list of users who cannot access
particular tables.

The `logs` table contains logged actions such as authentication events,
grant events, database resets and exceptions.

The `relations` table contains a list of table names and a brief
description.

Each page has a menu in the header which provides the user with the
ability to perform actions in the application.  Users with the role of
`SO` can perform any action, including resetting the application
database to its initial state.  Other roles can only view tables and
add entries to the `assigneds` table, if they have permission and the
grantee is not in the `forbiddens` table.

## Implementation of the permissions requirements

Most of the site was generated using the standard Rails scaffolding
commands and implements the standard Rails model-view-contoller
application.  Logging entries are inserted by the various controllers
when they implement a web request or when an event, such as a security
constraint is violated, occurs within application.  A user in the role
of security officer can review the logs.

The implementation of the security rules quoted above is carriend out
by two methods, `check_permissions` in RelationsController, and
`delete_chain` in AssignedsController.

The `check_permissions` determines whether a user has access to a
table.  It is used when another user grants access to a second user
and when the SO is inserting a user into the `forbiddens` table.  It
performs a breadth-first search of the permissions graph to insure the
user has access.

When the SO has inserted a user into the `forbiddens` table, the
`delete_chain` method removes users downstream of the inserted user by
traversing the graph and removing users who do not have access to the
table after the forbidden user's permissions have been revoked.
