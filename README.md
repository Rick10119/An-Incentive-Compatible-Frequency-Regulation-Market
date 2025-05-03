# Resource Market Clearing and Allocation System

This project implements a market clearing and resource allocation system for frequency regulation services in power systems. It includes optimization models for market clearing and resource allocation, with support for various types of resources including renewable energy, energy storage, and electric vehicles.

## Project Structure

The main components of the system are:

- `new_main.m`: Main script that orchestrates the market clearing and resource allocation process
- `new_clear.m`: Implements the market clearing optimization model
- `new_allocate.m`: Handles resource allocation optimization
- `new_bid.m`: Manages bidding strategies and cost calculations

## Resource Types

The system supports five types of resources:
1. Wind power (W)
2. Photovoltaic power (P)
3. Electric Vehicles (EV)
4. Energy Storage System 1 (ES1)
5. Energy Storage System 2 (ES2)

## Key Features

### Market Clearing
- Hourly market clearing for 24-hour horizon
- Considers both capacity and performance costs
- Supports up and down regulation services
- Uses Gurobi solver for optimization

### Resource Allocation
- Optimizes resource allocation based on AGC signals
- Handles different resource constraints and capabilities
- Considers opportunity costs for storage systems
- Supports symmetric resource allocation

### Bidding System
- Implements sophisticated bidding strategies for different resource types
- Considers opportunity costs for storage systems
- Handles different charging/discharging modes for energy storage
- Supports customizable ratios for different resource types

## Mathematical Models

### Market Clearing Model
- Objective: Minimize total cost (capacity + performance)
- Constraints:
  - Power balance (AGC signal matching)
  - Resource capacity limits
  - Resource quantity limits
  - Symmetric allocation requirements

### Resource Allocation Model
- Objective: Optimize resource utilization
- Constraints:
  - AGC signal requirements
  - Resource capacity constraints
  - Power regulation limits
  - Resource-specific operational constraints

## Usage

1. Ensure MATLAB and Gurobi solver are installed
2. Run `new_main.m` to start the market clearing and allocation process
3. The system will:
   - Clear the market for each hour
   - Allocate resources based on the clearing results
   - Calculate costs and prices

## Dependencies

- MATLAB
- Gurobi Optimizer
- YALMIP (for optimization modeling)

## Parameters

Key parameters can be adjusted in the code:
- `r`: Ratio for ES1
- `r2`: Ratio for ES2
- `rate`: Default rate
- `rate2`: Default rate 2
- `R_c_demand`: AGC demand (default: 5% of 1000MW)

## Outputs

The system generates:
- Market clearing prices
- Resource allocation results
- Cost calculations
- Performance metrics 

