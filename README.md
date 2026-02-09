# Agent Based Modelling : Price Determination with Evolutionary Strategies

This model attemts to create and simulate a basic production-consumption-trade cycle consisting of agents, capable of evolving feed-forward neural networks.

For detailed explanation and the report please refer to **Oezmen_ABM_final_report.pdf**

## Setup

Each agent is represented by a genome of 4 genes, where each represents the weights of a neural network that encodes production, consumption, trade and movement strategies. Each agent is also represented by set of rules, that decides their survival and movements and internal states like energy age etc.

The environment is a basic setup of 3 goods, that satisfies 3 different needs on different level, where 2 of the needs are being connected to survival and a 3rd luxary need. The ability to produce these good are related to spatial (location) and temporal (seasons)

The basic cycle goes like

- Produce
- Consume
- Exchange
- Move
- Mate 
- Evaluate Survival - Die

where, each agent can decide on production, consumption, exchange and move strategies. 

## Results

Since we don't really have an explicit goal given with rewards that defines the objectives we would like the agents to achieve, and evaluate them based on survival, only objective evaluation criteria is if there are a group of surviving induviduals creating a stable or drifting but stable enough system. 

Thus for evaluation, a single individual basically producing enough to survive forms a valid stable surviving group as well as a complex trading network. 

Thus, we evaluate the dynamics of this stable non stable systems and come up with strategies that drive evolution

#### Evolutionary Pressure

Since we have classified our systems into stable and unstable systems, one of the first problem in random search, is how to reach a stable system

One strategy for this is, creating random new indiduals at the beginning, until we get a group of individuals that can survive. However this can take a long time

One strategy we have observed to be working, is parametrizing the evolutionary pressure, by a variable for nutrition multiplyer that effects the value an agent would get from consuming a good (nutrition multiplyer x base nutrition). Starting with a high value (easy survival, don't even depend on trade, can sustain with own production), and gradually decreasing the value (harder survival, impossible to sustain itself by production), gives time for the individuals to stabilize and start trading, while increase in the pressure slowly kills the unsuccesfull individual driving the evolution

### Luxury Goods

We have observed that, having a luxury good, that doesn't effect survability directly, but increases the chance of mating, is very important. It has 2 important contributions:

- It acts as money in transaction. It's observed in many runs, that the luxury good is priced as 1.
- Agents cannot be too conservative. Even if they can survive by their own production, the agents taking the extra step for luxury goods get advantegous in the long run, dominating the population

![Image showing pricing of an individual for different goods in different trade cycles](assets/price.png)


### Population Genetics

We have observed, even if we start with random genomes, we end up with one or multiple (2-3) different populations. This is heavily affected by spatial location and trade dynamics. Once a population stabilizes and starts to grow then we see multiple strategies

There are two important rules to remember:

- You can only grow a product in dedicated regions and your production strategy is affected by your genes
- If you are close to trade, you are also close enough to mate, thus trading strategies has to come with genetic diffusion

  

- Conservatives
    - Do not trade
    - Individuals with novel strategies cannot survive so they are driven to a genetic diversity collapse
    - Usually expands until encountering another society, survival depends on how do they compete

- Traders
    - Tends to be the most succesfull group
    - Usually genetically more diverse, since they tend to contain individuals with different trading and production strategies
    - Less stable, since distruptions can break whole trade networks, leaving individuals ill-adapted to the new environment


![Image showing k-means clustering of genomes of agents](assets/kmeans.png)

### Trade Cycles

Through evolutionary pressure and luxury goods, we observe that societies that can coordinate emerges. This is not, in the classical term, optimizing a neural network, since the success of this neural network depends on the diversity and decisions of many other neural networks, in the following examples a whole society. 

We show an example of trade cycles happening. In each graph, agents are represented as humans, and goods are represented as colors, where R = "Fish", G = "Wheat - Luxary good", B = "Meat".

![Image showing production of agents](assets/p1.png)
![Image showing buy orders of agents in winter](assets/nt2.png)
![Image showing buy orders of agents in summer](assets/nt4.png)
![Image showing consumption of agents](assets/c3.png)
