# 01 02 03 04 05
# 06 07 08 09 10
# 11 12 13 14 15
# 16 17 18 19 20
# 21 22 23 24 25

# rotated...

# 21 16 11 06 01
# 22 17 12 07 02
# 23 18 13 08 03
# 24 19 14 09 04
# 25 20 15 10 05

# example translations:
# 0,0 => 0,4
# 0,1 => 1,4
# 0,2 => 2,4

# 1,0 => 0,3
# 1,1 => 1,3
# 1,2 => 2,3

# so the old Y position becomes the new X position
# and the new Y position is [number of sides] - [old X]

# m[0][3] is now @matrix[1][0]



class Matrix
  def matrix
    rv = ""
    @matrix.each_with_index do |a,i|
      rv += "#{a.join(" ")}\n"
    end
    return rv
  end

  def rotate_90_cw
    m = create_array @sides, false
    @sides.to_i.times do |x|
      @sides.to_i.times do |y|
        m[y][@sides-1-x] = @matrix[x][y]
      end
    end
    @matrix = m
    self
  end

  def create_array sides, fill=true
    m = []
    sides.to_i.times do |i|
      m.push generate_array sides, fill
    end
    m
  end

  def initialize args
    @sides = 1
    @matrix = []
    @iterator = 1


    @sides = args[:sides] if args.include? :sides
    @matrix = create_array @sides, true

  end

  def generate_array sides, fill=true
    a = []
    sides.times do |i|
      if fill
        a.push @iterator.to_s.rjust(2, '0')
        @iterator += 1
      else
        a.push 'xx'
      end
    end
    return a
  end

  def to_s
    return matrix
  end
end

m = Matrix.new(:sides => 5)
puts m
puts "\n\nAnd rotate...\n"
puts m.rotate_90_cw
