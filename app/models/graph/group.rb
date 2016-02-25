module Graph
  class Group
    include Neo4j::ActiveNode

    property :gid,            :constraint => :unique
    property :date_formed,    :type => Date

    # ISO-3166-1 alpha 2 (e.g. US, BE)
    property :country,        :index => :exact

    validates :gid,
                  :presence => true,
                  :format => { :with => /\A[a-z0-0]{8}-[a-z0-0]{4}-[a-z0-0]{4}-[a-z0-0]{4}-[a-z0-0]{12}\Z/ }

    has_many :out,
                  :group_names,
                  :type => :group_known_as,
                  :model_class => 'Graph::GroupName',
                  :dependent => :destroy

    has_many :in,
                  :artists,
                  :type => :member_of,
                  :model_class => 'Graph::Artist'

    has_many :out,
                  :lyrical_themes,
                  :type => :sings_about,
                  :model_class => 'Graph::LyricalTheme'

    has_one :out,
                  :country,
                  :type => :based_in,
                  :model_class => 'Graph::Country'

    has_many :out,
                  :data_sources,
                  :type => :described_by,
                  :model_class => 'Graph::DataSource'
  end
end
