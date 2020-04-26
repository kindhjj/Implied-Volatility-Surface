# Implied-Volatility-Surface

*Coded with MATLAB*

In FX markets the volatility surface is often described via a finite number of observations of
vanillas European options (call and puts) at different strikes and tenors expressed in delta
conventions. The purpose of this project is
- translate the observations into pairs of (strikes, volatilities);
- interpolate the marks so that we can then price European vanilla options with any strike
and maturity (interpolate a volatility surface);
- implement a numerical pricing framework to compute the price of any generic European
payoff (not just vanilla call and put options).

[Link to the report](doc/Project_Document.pdf)
