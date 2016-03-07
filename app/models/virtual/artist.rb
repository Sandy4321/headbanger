module Virtual
  def initialize(obj)
    puts obj
  end

  class Artist < DelegateClass(Graph::Artist)
    include Virtual::Virtualizable

    virtualize :date_of_birth,
                :source => :musicbrainz,
                :valid_for => :forever

    virtualize :date_of_death,
                :source => :musicbrainz,
                :valid_for => :forever

    virtualize :artist_names,
                :source => [:musicbrainz, :metal_archives]

    priority :musicbrainz => :very_high
  end

  class HeavyMetalArtist < Artist
    priority :metal_archives => :very_high,
              :musicbrainz => :high
  end
end
