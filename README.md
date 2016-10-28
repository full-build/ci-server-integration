Here are receipes for building on various CI

# Gerrit-Jenkins-Windows
folder gerrit-jenkins-windows allows you run a complete build (build-master.md) but also to build patches from gerrit (for verification).

build-master.md requires parameters in this order:

* base url of Gerrit server: ${GERRIT_SCHEME}://${GERRIT_HOST}:${GERRIT_PORT}/
* branch : branch to build (master for eg)
* buildall : true if build from scratch or false for incremental build

build-gerrit.md requires parameters in this order:

* repository: ${GERRIT_PROJECT} 
* branch: ${GERRIT_BRANCH}
* REFSPEC: ${GERRIT_REFSPEC} 
* base url of Gerrit server: ${GERRIT_SCHEME}://${GERRIT_HOST}:${GERRIT_PORT}/


