# Build ParFlow

``
docker build --pull -f docker/compute/parflow/Dockerfile -t kitware/hpccloud:parflow .
docker push kitware/hpccloud:parflow
``

# Test ParFlow
To run a test, navigate to the parflow repo's test directory, and run the image
on one of the tests.
```
cd parflow/test
docker run --rm -w /data -v $PWD:/data kitware/hpccloud:parflow default_single.tcl 1 1 1
```
