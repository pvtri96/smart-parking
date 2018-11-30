import {
  CssBaseline,
  AppBar,
  createStyles,
  Theme,
  Toolbar,
  Typography,
  withStyles,
  WithStyles,
  Grid
} from "@material-ui/core";
import * as React from "react";
import HelloDemo from "../Demo/Hello";
import FindParkingLots from "../Demo/FindParkingLots";
import ParkerBookParkingLots from '../Demo/ParkerBookParkingLots';
import GuardParkingLots from '../Demo/GuardParkingLots';
import { ContextProvider } from "./Context";

const styles = ({ spacing }: Theme) =>
  createStyles({
    root: {
      flexGrow: 1,
    },
    menuButton: {
      marginLeft: -18,
      marginRight: 10
    },
    container: {
      padding: spacing.unit * 2,
      width: '100%'
    }
  });

export class DenseAppBar extends React.Component<Props, States> {
  state = {
    requestKey: ""
  }

  render() {
    const { classes, children } = this.props;
    return (
      <div className={classes.root}>
        <CssBaseline />
        <AppBar position="static">
          <Toolbar variant="dense">
            <Typography variant="h6" color="inherit">
              API demo
            </Typography>
          </Toolbar>
        </AppBar>
        <ContextProvider value={{
          requestKey: this.state.requestKey,
          setState: (requestKey: string) => {
            this.setState({ requestKey });
          }
        }} >
        <Grid container spacing={16} className={classes.container}>
          <Grid item xs={12}>
            <HelloDemo />
          </Grid>
          <Grid item xs={4}>
            <FindParkingLots />
          </Grid>
          <Grid item xs={4}>
            <ParkerBookParkingLots />
          </Grid>
          <Grid item xs={4}>
            <GuardParkingLots />
          </Grid>
        </Grid>
        </ContextProvider>
      </div>
    );
  }
}

interface Props extends WithStyles<typeof styles> {
  children?: React.ReactNode;
}

interface States {
  requestKey: string
}

export default withStyles(styles)(DenseAppBar);
