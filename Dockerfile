FROM node:8

RUN npm install -g parcel-bundler linklocal

WORKDIR /user/

ENV API_BASE_URL=/api/
ENV IMAGE_BASE_URL=/images/
ENV PUBLIC_URL=/

EXPOSE 1234
EXPOSE 34365

# Should change to straight build
CMD ["./run-docker"]
