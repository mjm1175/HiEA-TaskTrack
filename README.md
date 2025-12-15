Rails Version: 8.8.1


Setup steps:
Install Ruby (version 3.4.7)

# Install JavaScript dependencies
Install node (version 24.11.1), yarn (version 1.22.22)

RUN bundle install

# Install node modules
RUN yarn install --immutable

RUN rm -rf node_modules

# Load assets for bootstrap reasons
RUN rails precompile:assets 

RUN rails s

OPEN: localhost:3000/projects or /projects


How to run tests:
RUN rails test


Example API requests (with query parameters).
GET /api/projects/1/tasks
GET /api/projects/1/tasks?status=todo
GET /api/projects/1/tasks?overdue=true
GET /api/projects/1/tasks?status=in_progress&overdue=true
GET /api/projects/1/tasks?status=done


Any notes on tradeoffs, shortcuts, or things you would improve with more time:

Assumptions: 
- Assuming default value of Task.status=todo and Task.priority=5. Reflected in form but shouldn’t be used outside of there. 
- Assuming that if a task is due today it is not overdue. 
- Assuming that a Task specific view was not a requirement. I implemented the mentioned “view” button as a show/hide feature for description only, as everything else is already displayed on the /project/:pid view. 
- I did not account for/error handle for unknown/random parameters given to things like the sort tasks function or the overdue url query. If handling for these was inside the scope of the assignment, I misunderstood but my assumption is that they were not.

Future Improvements:
- I would hide the View button from tasks with no description. I left it because it seemed like a requirement to have for each task.
- Friendly_id gem seems more beautiful and sensical for routes. /projects/projectname instead of /projects/projectid. But too many requirements relied on id number in route.
- Turbostream seems to allow in-place editing without the need for page reloads. I would look into this more for task delete. I looked into it but the simple switch wasn’t successful so I moved on, would revisit.
- I switched between doing things the way that felt most familiar/most efficient, most rails-y, and most readable. I would have preferred to have this reviewed by a rails-experienced peer and see if any of my choices are weird or have better solutions unbeknownst to me.
- Similar to above I would run this code through AI to check for the same improvements.
- I would have (and was planning to) provide string values to the array for acceptable status, it currently displays in_progress on the page, which is ugly.
- I would like to do another pass at error handling and edge case searching, I did not dedicate much time to this as the requirements didn’t request it but I am aware it is missing.
- Styling. 
