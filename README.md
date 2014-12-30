== README

Text-message-based scavenger hunt using Rails and the Twilio API. Admin will be able to design "missions" consisting of clues that are sent to the hunt's participants. They will also be able to track the participants' progress and see how many people have completed each challenge.

Currently a work in progress, but I am hoping to have an MVP up in early January.

== Features

### Participants

Initial Contact
* Participant text messages EP
* EP asks participant for their last name, or participant-specific code
* EP associates phone number with code or last name

Challenges
* EP sends participant a clue
* participant sends EP an answer
* EP responds with next challenge
* EP updates participant’s status to challenge level

Contact From Other Numbers
* Participant texts EP from another number
* EP asks for participant-specific code
* EP asks for last name
* EP associates phone number with code or last name

### Admin

Participant Analytics
* What percentage of participants have completed which challenges

Hand of God
* Ability to spontaneously text-message many participants randomly w/a single message

Missions
* Be able to create, read, update, and destroy new missions
* Be able to CRUD challenges and associate them with imssions

### Bonus (not MVP)
Picture-Based Challenge
* Participant texts EP a photograph of themselves
* Admin can approve picture-based challenges



