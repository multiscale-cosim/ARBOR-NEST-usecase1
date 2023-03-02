# ------------------------------------------------------------------------------
#  Copyright 2020 Forschungszentrum Jülich GmbH and Aix-Marseille Université
# "Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements; and to You under the Apache License,
# Version 2.0. "
#
# Forschungszentrum Jülich
# Institute: Institute for Advanced Simulation (IAS)
# Section: Jülich Supercomputing Centre (JSC)
# Division: High Performance Computing in Neuroscience
# Laboratory: Simulation Laboratory Neuroscience
# Team: Multi-scale Simulation and Design
# ------------------------------------------------------------------------------


### TODO... snippet below from Thorsten

import mpi4py as mpi
# Do mpi stuff
intercomm = (... magic MPI incantation commences ...)
world = mpi.WORLD

# Now to Arbor; note we don't need to touch Arbor until here, not even import it!
import arbor as A
ctx = A.context(WORLD, intercomm) # magic co-sim context
rec = recipe() # Here goes your simulation
sim = A.simulation(rec, ctx)
# do more stuff, as you like
# now run the simulation for a second
sim.run(1000 # ms,
        0.05 # ms
)
