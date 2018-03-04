# CS505p1

CS505 - project 1

This repository contains the code used for CS505, project 1, creating
a hybrid DAC/MAC authorization system for a database.  It implements a
Ruby-on-Rails web interface to the authorization system and implements
the following requirements taken from the assignment:

<quote>
 As mentioned above, he granularity of the privileges will be on the
 level of tables (i.e. we control the access to the entire
 table). Moreover, to simplify things a bit, instead of usual
 privileges (read, write, update, etc) we will have just one. Think
 about it as we give all of these privileges, or none at all. A user U
 may grant further privileges on a table T to user U' (i.e. the table
 assigned is inserted the record (U',T, B)) where B is a Boolean, if: 

    The table assigned contains the record (U,T,1)  
    The table forbidden does not contain the record (U',T) 

The Security Officer (SO) may edit both tables (i.e. assigned and
forbidden. If the SO attempts to modify the table forbidden by
inserting the record (U,T), then if there is record (U,T,B) in the
table permitted then this action (on the table assigned) is not at
first allowed, and the SO must execute the overwrite action on the
table assigned. Thus, after such action, the SO is warned that
inserting (U,T) into forbidden may result in disruption of operations
(because U' will no longer be able to access table T). Repeated action
of inserting (U',T) into forbidden will succeed, and moreover,
(U',T,G) will be removed from assigned, as well as all the subsequent
grants from U'. The forbidding action must be logged. 

When a user U issues a command `grant A to U' when the record (U',T)
is in forbidden then U will receive an error message `grant of access
to T by U' unacceptable' and SO receives a message that U attempted to
provide an access to U' to a restricted table. The lists must be
mutually consistent, that is, one can not have a permission for the
user (say) marek to access the table employees in the list assigned
and at the same time a record forbidding such access on the table
forbidden. The table forbidden can be modified only by SO.
</quote>
