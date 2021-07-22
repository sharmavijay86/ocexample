## How to use?
There are two files one is hpa example deployment. so deploy a sample php web application.
second is a dockerfile using which you can build a testbox image and you can push it to your registry, however there is an image available at my repo  sharmavijay86/testbox:v1
you can run the pod 

```
kubectl run testbox --image-pull-policy='Always' --image=sharmavijay86/testbox:v1 sleep 300
```
We are doing load test for hpa here so we can run.

create hpa first .
```
kubectl autoscale deployment php-apache --cpu-percent=80 --min=1 --max=4
```
Now get into this pod 
```
kubectl exec -it testbox -- sh
```
There are tools available for network related testing and etc. e.g.  wget, git, curl, nslookup, hey, ping, nmap, netstat, all busybox tools  and many more.


Now you can start giving traffic 
```
hey -c 2000 -n 3000 http://php-apache
```
Above will hit 2000 concurrent connections 3000  number of request will be executed.
bellow are the all options    
  -n  Number of requests to run. Default is 200.
  -c  Number of workers to run concurrently. Total number of requests cannot
      be smaller than the concurrency level. Default is 50.
  -q  Rate limit, in queries per second (QPS) per worker. Default is no rate limit.
  -z  Duration of application to send requests. When duration is reached,
      application stops and exits. If duration is specified, n is ignored.
      Examples: -z 10s -z 3m.
  -o  Output type. If none provided, a summary is printed.
      "csv" is the only supported alternative. Dumps the response
      metrics in comma-separated values format.

  -m  HTTP method, one of GET, POST, PUT, DELETE, HEAD, OPTIONS.
  -H  Custom HTTP header. You can specify as many as needed by repeating the flag.
      For example, -H "Accept: text/html" -H "Content-Type: application/xml" .
  -t  Timeout for each request in seconds. Default is 20, use 0 for infinite.
  -A  HTTP Accept header.
  -d  HTTP request body.
  -D  HTTP request body from file. For example, /home/user/file.txt or ./file.txt.
  -T  Content-type, defaults to "text/html".
  -a  Basic authentication, username:password.
  -x  HTTP Proxy address as host:port.
  -h2 Enable HTTP/2.

  -host	HTTP Host header.

  -disable-compression  Disable compression.
  -disable-keepalive    Disable keep-alive, prevents re-use of TCP
                        connections between different HTTP requests.
  -disable-redirects    Disable following of HTTP redirects
  -cpus                 Number of used cpu cores.
                        (default for current machine is 4 cores)

