import ../backend/image_data

type
  ImageInfo* = ref object
    data*: ImageData
    width*: float
    height*: float
    # loader: ImageLoaderBase # omitted for now
