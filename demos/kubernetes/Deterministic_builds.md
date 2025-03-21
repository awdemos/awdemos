## Buildkit

Here is some information about deterministic and reproducible builds with Nerdctl and BuildKit.

What are deterministic and reproducible builds?

A deterministic build is a build that always produces the same output, given the same inputs. A reproducible build is a build that can be reproduced on different machines, with different environments, see (https://en.wikipedia.org/wiki/Software_build).

In my opinion, container images in the current year should always be built to be deterministic to the bit level.

How can I build deterministic and reproducible images with nerdctl and BuildKit?

To build deterministic and reproducible images with nerdctl and BuildKit, you need to:

1. Ensure that you have nerdctl >= 0.18 and BuildKit >= 0.10.
2. Set up BuildKit with containerd worker.
3. Use a Dockerfile that is deterministic and reproducible.
4. Build the image with the `--buildkit` flag.

Here is an example of a Dockerfile that is deterministic and reproducible:


```sh
FROM ghcr.io/chainguard-images/wolfi-base:latest
RUN apk add --no-cache build-base
COPY . /app
WORKDIR /app
RUN make
CMD ["/app/my-app"]
```

To build the image with the `--buildkit` flag:

```sh
nerdctl build --buildkit .
```

This will build the image using BuildKit, and the resulting image will be deterministic and reproducible.

Here are some tips for building:

Deterministic and reproducible images:

- Use a base image that is deterministic and reproducible.
- Avoid using commands that are not deterministic, such as `date` and `uuidgen`.
- Use a caching mechanism to avoid rebuilding the same layers multiple times.
- Use a signing mechanism to verify the integrity of the image.

Benefits of deterministic and reproducible builds:

- Deterministic and reproducible builds can help to ensure that your images are always the same, regardless of where they are built.
- This can help to improve the reliability and security of your applications.
- Deterministic and reproducible builds can also help to make it easier to troubleshoot problems with your applications.

## Conclusion

Deterministic and reproducible builds are an important part of building reliable and secure applications. By following the tips above, you can build deterministic and reproducible images with nerdctl and BuildKit.

Source: (https://earthly.dev/blog/nerdctl/#:~:text=BuildKit%20Support,-BuildKit%20is%20a%20modern%2C)