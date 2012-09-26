#!/usr/bin/env python

# Make a legend for specific lines.
from pylab import *

import time
from datetime import datetime as d
from datetime import timedelta as dt

start_date = d(2012, 9, 22)
end_date = d(2012, 11, 10)


squat = [
    (d(2012,9,24), 175, 5, 1),
    (d(2012,9,27), 180, 2, 1),
    (d(2012,10,2), 180, 5, 1),
    (d(2012,10,4), 170, 1, 1),
    (d(2012,10,9), 190, 3, 1),
    (d(2012,10,13), 190, 1, 1),
    (d(2012,10,16), 195, 2, 1),
    (d(2012,10,18), 170, 1, 1),
    (d(2012,10,23), 200, 2, 1),
    (d(2012,10,30), 200, 1, 1),
    (d(2012,11,01), 205, 1, 1),
    (d(2012,11,10), 210, 1, 1)
]

dead = [
    (d(2012,9,22), 180, 5, 3), # 210x1
    (d(2012,9,28), 190, 5, 2), # 215x1
    (d(2012,10,4), 200, 3, 3), # 220x1
    (d(2012,10,6), 225, 1, 1), # TSC
    (d(2012,10,11), 210, 3, 1), # 230x1
    (d(2012,10,17), 220, 2, 1), # 235x1
    (d(2012,10,27), 245, 1, 1),
    (d(2012,11,10), 250, 1, 1)
]

def fill_values(lifts):
    """
    [("yyyy-mm-dd", weight, reps, sets), ...]
    """

    vs = []
    date = start_date
    one_day = dt(days=1)
    while date != end_date:
        vs.append([date, 0, 0]) # (date.strftime("%Y-%m-%d"), 0, 0))
        date += one_day
    # and end date
    vs.append([date, 0, 0]) # (date.strftime("%Y-%m-%d"), 0, 0))

    for dtime, w, r, s in lifts:
        for i in range(len(vs)):
            if vs[i][0] == dtime:
                if r == 1:
                    cw = w
                else:
                    cw = w*(1 + 0.033*r)
                vs[i][1] = cw
                vs[i][2] = s
                break

    # smooth out between values where 0
    i = 0
    j = 0
    s = 0
    e = 0

    # skip past any initial zeroes
    while i < len(vs) and vs[i][1] == 0:
        i += 1

    while i < len(vs):

        while i < len(vs) and vs[i][1] != 0:
            i += 1

        s = i-1

        while i < len(vs) and vs[i][1] == 0:
            i += 1

        if i >= len(vs):
            break

        e = i

        start, end = vs[s][1], vs[e][1]
        delta = (end - start) / float(e - s)
        print s, e, start, end, delta

        v = start + delta
        for j in range(s+1, e):
            vs[j][1] = v
            v += delta

    print "----------------------------"
    for v in vs:
        print v

    return vs

deads = fill_values(dead); plot([x[0] for x in deads], [x[1] for x in deads], "r-")
squats = fill_values(squat); plot([x[0] for x in squats], [x[1] for x in squats], "g-")

#t1 = array([dobj.tm_yday for dateprint, dobj in range(day_count)])

# note that plot returns a list of lines.  The "l1, = plot" usage
# extracts the first element of the list inot l1 using tuple
# unpacking.  So l1 is a Line2D instance, not a sequence of lines

#l1,    = plot(t1, exp(-t1), 'r-')
#l2,    = plot(t1, exp(-t1/2), '--g')

#plot(t1, t1)

#locs, labels = xticks()

#l2, l3 = plot(t2, sin(2*pi*t2), '--go', t1, log(1+t1), '.')
#l4,    = plot(t2, exp(-t2)*sin(2*pi*t2), 'rs-.')

#legend( (l2, l4), ('oscillatory', 'damped'), 'upper right', shadow=True)
#xlabel('time')
#ylabel('volts')
#title('Damped oscillation')
#axis([0,2,-1,1])

axis(ymin=160, ymax=260)

show()

