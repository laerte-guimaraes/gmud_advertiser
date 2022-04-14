module PullRequestParser
  TOPICS = [
    "## O que mudou\r\n",
    "## Riscos\r\n",
    "## Impactos negativos previstos\r\n"
  ].freeze

  DESCRIPTION_TOPIC = [:changes, :riskiness].to_enum

  module_function

  def gmud_hash(gmud)
    description = {
      repository: gmud['head']['repo']['name'].capitalize,
      number: gmud['number'],
      link: gmud['html_url'],
      changes: '',
      riskiness: '' 
    }

    topic = nil

    gmud['body'].each_line do |line|
      if TOPICS.include?(line)
        topic = DESCRIPTION_TOPIC.next
        next
      end

      description[topic]&.concat(line) unless line.strip.empty?
    end
  rescue StopIteration
    description
  end
end
