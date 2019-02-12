class FileServer

  MIME_TYPES = {
    '.txt' => 'text/plain',
    '.jpg' => 'image/jpeg',
    '.zip' => 'application/zip'
  }

  def initialize(root)
    @root = root
  end

  def call(env)
    res = Rack::Response.new
    file_name = requested_file_name(env)

    if File.exist?(file_name)
      serve_file(file_name, res)
    else
      res.status = 404
      res.write("File not found")
    end
    res
  end

  private

  def serve_file(file_name, res)
    extension = File.extname(file_name)
    content_type = MIME_TYPES[extension]
    file = File.read(file_name)
    res["Content-type"] = content_type
    res.write(file)
  end

  def requested_file_name(env)
    req = Rack::Request.new(env)
    path = req.path
    dir = File.dirname(__FILE__)
    File.join(dir, '..', '..', path)
  end
end