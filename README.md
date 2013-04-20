# simple-open-ni

This is the simple-open-ni that [bifocals][bif] depends on. It's just
[SimpleOpenNI][soni]'s jar with all its native libraries repackaged into it, in the way
that leiningen expects.

[bif]: https://github.com/aperiodic/bifocals
[soni]: https://code.google.com/p/simple-openni/

Really the only slightly non-trivial thing here `jar.sh` script that will, given
a version string for SimpleOpenNI (such as '0.27'), download that release and
perform the repackaging. The resultant jar (which will show up in the current
directory) can then be uploaded to clojars. You'll need to change the groupid
in the pom, though.

If you find yourself needing to change this, it probably means there's a new release of
SimpleOpenNI that I haven't noticed yet, so please open an issue on this project
so I can update the canonical clojars jar and [bifocals][bif].
