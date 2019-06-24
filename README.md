
In this article we will use JWT to implement the full version of the authorization mechanism Authorization.

http://localhost:8080 
## you can change port application.yml file


There are many ways to authorize, nothing more than to distinguish users by ID and Role.
Because of the flexibility of JWT, we can put the user ID in jwt.
Because the user calls our api will be accompanied by JWT, which is equivalent to direct The user ID is attached.

### Put the user ID into jwt
we only need to add the JWT claims in the form of key-value before generating the JWT `map.put("userId","1"); map.put("role","admin");`.
My demo here puts a symbolic ("userId", "admin") into it.

```
public static String generateToken(String id) {
        HashMap<String, Object> map = new HashMap<>();
        //you can put any data in the map
        map.put("userId", id);
        ---- some unimportant code
        String jwt = Jwts.builder()
                .setClaims(map)
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                .signWith(SignatureAlgorithm.HS512, SECRET)
                .compact();
        return jwt;
    }
```
Then you can get such a jwt
```
jwt:
eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1MjAyODQ2NDEsInVzZXJJZCI6ImFkbWluIn0.ckcDMFWWYh8QOSYGxbOGZywSebWpXjF4mZOX2eWEycMb7BT7tHh8EjWSCC5EZLqKggY1uBuhpq8EvVE-Tzl7fw
Base64: ## After Decoding
{"alg":"HS512"}{"exp":1520284641,"userId":"admin"}
```
### Put the ID after decoding the JWT into the header
The userId we added in JWT is very inconvenient to use, because only the original JWT string can be obtained in RestController,
and additional code is required to read the contents.We hope that RestController can directly get the content we put in JWT. 
Here is a clever way to verify the jwt and put the decoded ID into the header of the request HttpSevletRequest.
It is equivalent to adding a Header. userId" : "admin". In this case, the use of this header in the RestController 
is as simple as the following example. It can be used as a normal header. Verify that the JWT code has helped you get your dirty work done.
```
    @GetMapping("/api/protected")
    public @ResponseBody Object hellWorld(@RequestHeader(value = USER_ID) String userId) {
        return "Hello World! This is a protected api, your use id is "+userId;
    }
```

The method of putting userId into HttpServletRequest is quite clever.
After verifying JWT, you need to replace the original HttpServletRequest with our packaged one.

```
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        ... 
            if(pathMatcher.match(protectUrlPattern, request.getServletPath())) {
                //Replaced the original request here
                request = JwtUtil.validateTokenAndAddUserIdToHeader(request);
            }
        ... 
        filterChain.doFilter(request, response);
    }
...
}

public class JwtUtil {
    public static HttpServletRequest validateTokenAndAddUserIdToHeader(HttpServletRequest request) {
        String token = request.getHeader(HEADER_STRING);
            // parse the token.
            Map<String, Object> body = Jwts.parser()
                        .setSigningKey(SECRET)
                        .parseClaimsJws(token.replace(TOKEN_PREFIX, ""))
                        .getBody();
            String userId = (String) body.get(USER_ID);
            //The following line of code is very important, modify the Request through CustomHttpServletRequest
            return new CustomHttpServletRequest(request, EncryptUtil.decrypt(userId));
            ... 
    }
...
}
```

###Modify the HttpServletRquest method:
The way to inject the ID into HttpServletRquest is to inherit the HttpServletRequestWrapper and override the getHeaders method. 
This way the spring web framework calls getHeaders("userId") to get this value.
```
public static class CustomHttpServletRequest extends HttpServletRequestWrapper {
        private String userId;

        public CustomHttpServletRequest(HttpServletRequest request, String userId) {
            super(request);
            this.userId = userId;
        }

        @Override
        public Enumeration<String> getHeaders(String name) {
            if (name != null && (name.equals(USER_ID))) {
                return Collections.enumeration(Arrays.asList(userId));
            }
            return super.getHeaders(name);
        }
    }
```
The final effect is like this, the api can know from the jwt how much the user's id is.


# JWT
